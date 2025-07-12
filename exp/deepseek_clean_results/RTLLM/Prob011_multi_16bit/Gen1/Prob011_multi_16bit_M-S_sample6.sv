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

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            count <= 4'b0;
            done <= 1'b0;
            yout <= 32'b0;
        end
        else if (start) begin
            if (count == 0) begin
                // Initialize on first cycle
                areg <= ain;
                breg <= bin;
                acc <= 32'b0;
                count <= count + 1;
                done <= 1'b0;
            end
            else if (count <= 15) begin
                // Processing cycles
                if (areg[count-1]) begin
                    acc <= acc + (breg << (count-1));
                end
                count <= count + 1;
                done <= (count == 15); // Set done one cycle early
            end
            else begin
                // Final cycle (count = 16)
                yout <= acc;
                count <= 0;
                done <= 1'b0;
            end
        end
        else begin
            // Idle state
            count <= 0;
            done <= 1'b0;
        end
    end

endmodule