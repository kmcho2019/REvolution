module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state;
reg [1:0] next_state;

// One-hot encoding for states
localparam STATE_A = 2'b01;
localparam STATE_B = 2'b10;

always @(*) begin
    case(state)
        STATE_A: begin
            z = x;
            if(x == 0) begin
                next_state = STATE_A;
            end else begin
                next_state = STATE_B;
            end
        end
        STATE_B: begin
            z = ~x;
            next_state = STATE_B;
        end
        default: begin
            next_state = STATE_A;
            z = 0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= STATE_A;
    end else begin
        state <= next_state;
    end
end

endmodule