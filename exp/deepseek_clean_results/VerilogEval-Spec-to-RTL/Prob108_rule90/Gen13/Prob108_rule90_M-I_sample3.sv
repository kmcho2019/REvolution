module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [2:0] state;
    reg [511:0] next_q;
    reg [63:0] left_chunk, right_chunk;
    integer i;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            state <= 0;
        end else begin
            case (state)
                0: begin // Prepare first chunk
                    left_chunk <= {1'b0, q[511:449]};
                    right_chunk <= {q[510:448], 1'b0};
                    state <= 1;
                end
                1, 2, 3, 4, 5, 6, 7: begin // Process chunks
                    next_q[state*64 +: 64] <= left_chunk ^ right_chunk;
                    
                    if (state < 7) begin
                        left_chunk <= {1'b0, q[(state*64)+511 -: 64]};
                        right_chunk <= {q[(state*64)+510 -: 64], 1'b0};
                    end
                    state <= state + 1;
                end
                8: begin // Final update
                    q <= next_q;
                    state <= 0;
                end
            endcase
        end
    end

endmodule