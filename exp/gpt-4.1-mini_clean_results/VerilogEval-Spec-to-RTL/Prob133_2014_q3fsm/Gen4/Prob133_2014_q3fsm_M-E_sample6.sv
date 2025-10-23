module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic [1:0] {A=2'd0, B1=2'd1, B2=2'd2, B3=2'd3} state_t;
    state_t state, next_state;

    reg [1:0] w_count;  // count of w=1 in current 3-cycle window

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                A: begin
                    w_count <= 2'd0;
                    z <= 1'b0;
                end
                B1: begin
                    w_count <= w;  // start counting with w from first cycle
                    z <= 1'b0;
                end
                B2: begin
                    w_count <= w_count + w;
                    z <= 1'b0;
                end
                B3: begin
                    // Final cycle: add w, then set z based on total count
                    w_count <= 2'd0; // reset count for next sequence
                    z <= ((w_count + w) == 2) ? 1'b1 : 1'b0;
                end
                default: begin
                    w_count <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            A: next_state = s ? B1 : A;
            B1: next_state = B2;
            B2: next_state = B3;
            B3: next_state = B1;
            default: next_state = A;
        endcase
    end

endmodule