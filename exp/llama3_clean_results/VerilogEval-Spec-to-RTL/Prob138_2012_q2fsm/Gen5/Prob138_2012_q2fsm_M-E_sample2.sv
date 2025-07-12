module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// State codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Sub-state codes
parameter SUB_STATE_1 = 1'b0;
parameter SUB_STATE_2 = 1'b1;

// State register
reg [2:0] state;
reg sub_state;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        sub_state <= SUB_STATE_1;
    end else begin
        case (sub_state)
            SUB_STATE_1: begin
                case (state)
                    A: state <= w? B : A;
                    B: state <= w? C : D;
                    C: state <= w? (w? SUB_STATE_2 : D) : D;
                    D: state <= w? (sub_state == SUB_STATE_1? D : F) : A;
                    default: state <= A;
                endcase
            end
            SUB_STATE_2: begin
                case (state)
                    C: state <= w? C : D;
                    D: state <= w? D : D;
                    default: state <= C;
                endcase
            end
            default: begin
                state <= A;
                sub_state <= SUB_STATE_1;
            end
        endcase
    end
end

// Output logic
assign z = (sub_state == SUB_STATE_2);

endmodule