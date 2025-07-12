module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]  count;       // shift count: 0 idle, 1..16 active, 17 done reset
    reg [31:0] product;     // upper 16 bits accumulate partial sums, lower 16 bits multiplier
    reg [15:0] multiplicand;
    reg        done_r;

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count       <= 5'd0;
            product     <= 32'd0;
            multiplicand<= 16'd0;
            done_r      <= 1'b0;
        end else begin
            case (count)
                5'd0: begin // idle state, wait for start
                    done_r <= 1'b0;
                    if (start) begin
                        multiplicand <= ain;
                        product     <= {16'd0, bin}; // load multiplier into lower half
                        count       <= 5'd1;
                    end
                end
                5'd1,5'd2,5'd3,5'd4,5'd5,5'd6,5'd7,5'd8,
                5'd9,5'd10,5'd11,5'd12,5'd13,5'd14,5'd15,5'd16: begin
                    // Perform shift and accumulate
                    if (product[0]) 
                        product <= (product >> 1) + ( {multiplicand,16'd0} >> 1 );
                    else
                        product <= product >> 1;
                    count <= count + 5'd1;
                end
                5'd17: begin
                    done_r <= 1'b1;   // multiplication complete
                    count  <= 5'd0;   // reset count to idle after done
                end
                default: begin
                    count <= 5'd0;
                    done_r <= 1'b0;
                end
            endcase
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule