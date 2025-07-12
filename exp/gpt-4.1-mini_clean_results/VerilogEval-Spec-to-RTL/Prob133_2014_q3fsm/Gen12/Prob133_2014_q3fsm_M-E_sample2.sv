module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: 2 bits for 4 states (A, B0, B1, B2)
    localparam [1:0]
        A  = 2'b00,
        B0 = 2'b01,
        B1 = 2'b10,
        B2 = 2'b11;

    reg [1:0] state;
    reg [2:0] w_shift;  // shift register to hold last 3 w samples

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_shift <= 3'b000;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    if (s) begin
                        state <= B0;
                        w_shift <= 3'b000; // clear shift register when entering B states
                    end
                end
                B0: begin
                    z <= 1'b0;
                    w_shift <= {w_shift[1:0], w}; // shift in current w
                    state <= B1;
                end
                B1: begin
                    z <= 1'b0;
                    w_shift <= {w_shift[1:0], w};
                    state <= B2;
                end
                B2: begin
                    w_shift <= {w_shift[1:0], w};
                    // count number of 1's in w_shift + new w
                    // but since w_shift has last two, and we append w now, w_shift after update has 3 samples
                    // count bits in w_shift
                    // Use a simple count by addition:
                    integer count_ones;
                    count_ones = w_shift[0] + w_shift[1] + w_shift[2];
                    z <= (count_ones == 2) ? 1'b1 : 1'b0;
                    state <= B0; // loop to next 3-cycle window
                end
                default: begin
                    state <= A;
                    z <= 1'b0;
                    w_shift <= 3'b000;
                end
            endcase
        end
    end

endmodule