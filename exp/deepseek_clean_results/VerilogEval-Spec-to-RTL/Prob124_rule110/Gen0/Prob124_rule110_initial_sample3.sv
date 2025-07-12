module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Apply Rule 110 to each cell
            q[0] <= (1'b0 /*left*/ | q[0]) ^ q[1]; // left boundary is 0
            q[511:1] <= (q[510:0] | q[511:1]) ^ q[511:1] ^ q[512:2]; // right boundary is 0
            
            // Alternative implementation that's more readable:
            // for (integer i = 0; i < 512; i = i+1) begin
            //     reg left, right;
            //     left = (i == 0) ? 1'b0 : q[i-1];
            //     right = (i == 511) ? 1'b0 : q[i+1];
            //     q[i] <= right ^ (left | q[i]);
            // end
        end
    end

    // More explicit implementation of Rule 110:
    /*
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 512; i = i+1) begin
                reg left, center, right;
                left = (i == 0) ? 1'b0 : q[i-1];
                center = q[i];
                right = (i == 511) ? 1'b0 : q[i+1];
                
                case ({left, center, right})
                    3'b111: q[i] <= 1'b0;
                    3'b110: q[i] <= 1'b1;
                    3'b101: q[i] <= 1'b1;
                    3'b100: q[i] <= 1'b0;
                    3'b011: q[i] <= 1'b1;
                    3'b010: q[i] <= 1'b1;
                    3'b001: q[i] <= 1'b1;
                    3'b000: q[i] <= 1'b0;
                endcase
            end
        end
    end
    */

endmodule