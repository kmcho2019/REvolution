module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // Define states
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Combined counter for cycles and w tracking
    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'b00;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z <= 1'b0;
                    if (s) begin
                        state <= B;
                        count <= 2'b00;
                    end
                end
                B: begin
                    if (count == 2'b10) begin
                        // End of 3-cycle window
                        z <= (count[1] ^ count[0]) & w; // Equivalent to w_count == 2
                        count <= 2'b00;
                    end else begin
                        count <= count + {1'b0, w};
                        z <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule