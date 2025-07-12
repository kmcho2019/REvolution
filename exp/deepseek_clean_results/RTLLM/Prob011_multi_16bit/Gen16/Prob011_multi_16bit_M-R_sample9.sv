module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    reg [3:0] count;
    reg [15:0] areg;
    reg [31:0] acc;
    reg active;

    // Counter and control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0;
            active <= 1'b0;
            areg <= 16'b0;
            acc <= 32'b0;
        end else begin
            if (start && !active) begin
                // Start new multiplication
                active <= 1'b1;
                count <= 4'b0;
                areg <= ain;
                acc <= 32'b0;
            end else if (active) begin
                if (count < 15) begin
                    count <= count + 1;
                end else begin
                    active <= 1'b0;
                end

                // Accumulate if current bit is set
                if (areg[count]) begin
                    acc <= acc + (bin << count);
                end
            end
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (active && (count == 15));

endmodule