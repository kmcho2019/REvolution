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
    reg [15:0] breg;
    reg running;

    // Counter and control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0;
            running <= 1'b0;
        end else begin
            if (start && !running) begin
                running <= 1'b1;
                count <= 4'b0;
            end else if (running) begin
                if (count == 15) begin
                    running <= 1'b0;
                end
                count <= count + 1;
            end
        end
    end

    // Data path registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            acc <= 32'b0;
            breg <= 16'b0;
        end else begin
            if (start && !running) begin
                areg <= ain;
                breg <= bin;
                acc <= 32'b0;
            end else if (running) begin
                if (areg[count]) begin
                    acc <= acc + (breg << count);
                end
            end
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (count == 15) && running;

endmodule