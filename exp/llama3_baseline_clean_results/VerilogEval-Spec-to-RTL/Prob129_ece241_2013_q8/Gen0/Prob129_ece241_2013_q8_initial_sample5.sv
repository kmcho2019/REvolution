module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

// Define states
localparam IDLE = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

reg [1:0] state, next_state;

// Reset logic
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state <= S1;
            end else begin
                next_state <= IDLE;
            end
        end
        S1: begin
            if (~x) begin
                next_state <= S2;
            end else begin
                next_state <= S1;
            end
        end
        S2: begin
            if (x) begin
                next_state <= S1;
            end else begin
                next_state <= S2;
            end
        end
        default: next_state <= IDLE;
    endcase
end

// Output logic
assign z = (state == S2 && x);

endmodule