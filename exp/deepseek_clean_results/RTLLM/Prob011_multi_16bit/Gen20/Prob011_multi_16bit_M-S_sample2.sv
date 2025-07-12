module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] count;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'd0;
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            done <= 1'b0;
        end else begin
            if (start) begin
                if (count == 0) begin
                    // Load operands and initialize
                    areg <= ain;
                    breg <= bin;
                    acc <= 32'b0;
                    count <= count + 1;
                    done <= 1'b0;
                end else if (count <= 16) begin
                    // Shift and accumulate
                    if (areg[count-1]) begin
                        acc <= acc + (breg << (count-1));
                    end
                    count <= count + 1;
                    done <= (count == 15);
                end
            end else begin
                count <= 4'd0;
                done <= 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (count == 17) begin
            yout <= acc;
        end
    end

endmodule