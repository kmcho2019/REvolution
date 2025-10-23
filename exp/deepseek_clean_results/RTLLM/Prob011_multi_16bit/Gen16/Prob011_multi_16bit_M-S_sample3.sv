module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output wire done
);

    reg [3:0] count;
    reg [15:0] areg;
    reg [15:0] breg;
    reg running;

    assign done = (count == 15) && running;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0;
            areg <= 16'b0;
            breg <= 16'b0;
            yout <= 32'b0;
            running <= 1'b0;
        end else begin
            if (start && !running) begin
                // Initialize operation
                areg <= ain;
                breg <= bin;
                yout <= 32'b0;
                count <= 4'b0;
                running <= 1'b1;
            end else if (running) begin
                // Shift and accumulate
                if (areg[count]) begin
                    yout <= yout + (breg << count);
                end

                // Update counter
                if (count == 15) begin
                    running <= 1'b0;
                end else begin
                    count <= count + 1;
                end
            end
        end
    end

endmodule