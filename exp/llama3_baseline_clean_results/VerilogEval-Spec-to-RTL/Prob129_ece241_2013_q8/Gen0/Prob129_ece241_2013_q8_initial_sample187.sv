module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

// Declare state variable
reg [1:0] state;
reg [1:0] next_state;

// Declare output variable
reg z_reg;
assign z = z_reg;

// Asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        S0: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (~x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1;
                z_reg = 1'b1;
            end else begin
                next_state = S0;
                z_reg = 1'b0;
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end

// Set z to 0 if not in the correct state
always @(posedge clk) begin
    if (state != S2 || ~x) begin
        z_reg <= 1'b0;
    end
end

endmodule