module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // FSM states
    localparam A = 2'd0; // waiting for s=1
    localparam B = 2'd1; // collecting w samples (3 cycles)
    localparam C = 2'd2; // output z for 1 cycle, then go back to B

    reg [1:0] state;
    reg [1:0] sample_count;  // counts how many w samples collected (0 to 2)
    reg [2:0] w_shift;       // shift register holding last 3 w samples

    // Function to count number of 1's in 3-bit input
    function [1:0] popcount3;
        input [2:0] val;
        begin
            // sum bits manually
            popcount3 = val[0] + val[1] + val[2];
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            sample_count <= 2'd0;
            w_shift <= 3'd0;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    sample_count <= 2'd0;
                    w_shift <= 3'd0;
                    if (s)
                        state <= B;
                    else
                        state <= A;
                end

                B: begin
                    z <= 1'b0;
                    w_shift <= {w_shift[1:0], w}; // shift in current w
                    if (sample_count == 2'd2) begin
                        // collected 3 samples, move to output state
                        state <= C;
                        sample_count <= 2'd0;
                    end else begin
                        sample_count <= sample_count + 2'd1;
                        state <= B;
                    end
                end

                C: begin
                    // Count number of ones in w_shift
                    z <= (popcount3(w_shift) == 2);
                    // After output cycle, start next 3-cycle collection
                    state <= B;
                    sample_count <= 2'd0;
                    w_shift <= 3'd0;
                end

                default: begin
                    // Defensive reset state
                    state <= A;
                    sample_count <= 2'd0;
                    w_shift <= 3'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule