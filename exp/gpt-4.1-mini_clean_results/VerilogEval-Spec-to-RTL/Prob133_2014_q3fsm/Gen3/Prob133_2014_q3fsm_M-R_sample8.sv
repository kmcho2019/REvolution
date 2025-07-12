module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic [2:0] {
        A  = 3'd0,
        B0 = 3'd1, // first w sample cycle
        B1 = 3'd2, // second w sample cycle
        B2 = 3'd3, // third w sample cycle
        B3 = 3'd4  // output cycle
    } state_t;

    state_t state, next_state;
    reg [1:0] w_count; // count number of w=1 in three cycles

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
                B0: begin
                    w_count <= w;
                    z <= 1'b0;
                end
                B1: begin
                    w_count <= w_count + w;
                    z <= 1'b0;
                end
                B2: begin
                    w_count <= w_count + w;
                    z <= 1'b0;
                end
                B3: begin
                    // output z=1 if exactly two w=1 in last three cycles
                    z <= (w_count == 2) ? 1'b1 : 1'b0;
                    w_count <= 2'd0; // reset count for next batch
                end
                default: begin
                    w_count <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

    always @(*) begin
        case(state)
            A:  next_state = (s) ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B3;
            B3: next_state = B0;
            default: next_state = A;
        endcase
    end

endmodule