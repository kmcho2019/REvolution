module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output wire done
);

    reg [4:0] count;  // Need 5 bits to count to 16 (0-16)
    reg [31:0] acc;

    // Combinational done signal
    assign done = (count == 16);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            acc <= 32'd0;
            yout <= 32'd0;
        end else begin
            if (start) begin
                if (count == 0) begin
                    // First cycle - initialize
                    acc <= 32'd0;
                    count <= count + 1;
                end else if (count <= 16) begin
                    // Calculation cycles
                    if (ain[count-1]) begin
                        acc <= acc + (bin << (count-1));
                    end
                    count <= count + 1;
                end
            end else begin
                // Not started or completed
                count <= 5'd0;
                yout <= acc;
            end
        end
    end

endmodule