module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    reg [4:0] count;  // Counts 0-16 (needs 5 bits)
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
        end else begin
            if (start && count == 0) begin
                // Load operands on first cycle
                areg <= ain;
                breg <= bin;
                acc <= 32'b0;
                count <= count + 1;
            end else if (count > 0 && count < 17) begin
                // Shift-and-add for 16 cycles
                if (areg[count-1]) begin
                    acc <= acc + (breg << (count-1));
                end
                count <= count + 1;
            end else if (count == 17) begin
                // Reset after completion
                count <= 5'd0;
            end
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (count == 16);  // Done is high for one cycle

endmodule