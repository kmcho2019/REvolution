module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Control signals
    reg [4:0] count;
    wire count_en = start && !done && (count < 16);
    wire count_rst = !rst_n || (!start && count == 0);
    
    // Datapath registers
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;
    reg zero_flag;

    // Early termination when multiplier is zero
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            zero_flag <= 1'b0;
        end else if (start && count == 0) begin
            zero_flag <= (bin == 16'b0);
        end
    end

    // Control logic (counter)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
        end else if (count_rst) begin
            count <= 5'd0;
        end else if (count_en) begin
            count <= count + 1;
        end
    end

    // Datapath logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            done <= 1'b0;
        end else if (start) begin
            if (count == 0) begin
                areg <= ain;
                breg <= bin;
                acc <= 32'b0;
                done <= zero_flag;
            end else if (count < 16) begin
                if (areg[count-1]) begin
                    acc <= acc + (breg << (count-1));
                end
                done <= (count == 15);
            end else begin
                done <= 1'b1;
            end
        end else begin
            done <= 1'b0;
        end
    end

    // Output assignment
    always @(*) begin
        yout = zero_flag ? 32'b0 : acc;
    end

endmodule