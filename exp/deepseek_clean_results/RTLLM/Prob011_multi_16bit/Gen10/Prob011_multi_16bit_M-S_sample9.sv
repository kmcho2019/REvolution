module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output wire done
);

    reg [3:0] i;            // Shift counter (0-15)
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] acc;         // Accumulator register

    // Counter and control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            acc <= 32'd0;
        end
        else if (start) begin
            if (i == 4'd0) begin
                // Load phase
                areg <= ain;
                breg <= bin;
                acc <= 32'd0;
                i <= i + 1;
            end
            else if (i < 4'd16) begin
                // Calculation phase
                if (areg[i-1])
                    acc <= acc + (breg << (i-1));
                i <= i + 1;
            end
        end
        else begin
            i <= 4'd0;
        end
    end

    // Output assignments
    assign done = (i == 4'd16);
    always @(*) yout = acc;

endmodule