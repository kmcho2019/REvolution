module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

// Define one-hot encoding for states
reg [1:0] state;
reg [1:0] next_state;

// Define one-hot encoding for states
localparam STATE_A = 2'b01;
localparam STATE_B = 2'b10;

// Combinational logic for next state and output z
always @(*) begin
    case (state)
        STATE_A: begin
            if (x == 0) begin
                next_state = STATE_A;
                z = 0;
            end else begin
                next_state = STATE_B;
                z = 1;
            end
        end
        STATE_B: begin
            if (x == 0) begin
                next_state = STATE_B;
                z = 1;
            end else begin
                next_state = STATE_B;
                z = 0;
            end
        end
        default: begin
            next_state = STATE_A;
            z = 0;
        end
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_A;
    end else begin
        state <= next_state;
    end
end

endmodule