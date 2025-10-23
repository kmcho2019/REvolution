module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [15:0] areg, breg;
    reg [31:0] acc;
    reg [3:0] count; // 4-bit counter (0-15)
    reg [31:0] shifted_b;
    reg processing;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            count <= 4'b0;
            done <= 1'b0;
            yout <= 32'b0;
            shifted_b <= 32'b0;
            processing <= 1'b0;
        end
        else begin
            // Default assignments
            done <= 1'b0;
            
            if (start && !processing) begin
                // Start new multiplication
                areg <= ain;
                breg <= bin;
                acc <= 32'b0;
                count <= 4'b0;
                processing <= 1'b1;
                shifted_b <= {16'b0, bin};
            end
            else if (processing) begin
                if (count < 15) begin
                    // Processing cycles
                    if (areg[count]) begin
                        acc <= acc + shifted_b;
                    end
                    
                    // Pre-calculate next shift
                    shifted_b <= shifted_b << 1;
                    count <= count + 1;
                end
                else begin
                    // Final cycle (count == 15)
                    if (areg[count]) begin
                        acc <= acc + shifted_b;
                    end
                    
                    // Operation complete
                    yout <= (areg[count]) ? acc + shifted_b : acc;
                    done <= 1'b1;
                    processing <= 1'b0;
                end
            end
        end
    end

endmodule