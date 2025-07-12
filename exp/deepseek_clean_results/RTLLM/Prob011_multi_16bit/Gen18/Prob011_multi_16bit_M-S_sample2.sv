module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // Control signals
    reg [4:0] count;
    wire count_en = start && (count < 16);
    wire op_done = (count == 16);

    // Datapath registers
    reg [31:0] acc;
    reg [15:0] shifted_bin;
    
    // Control logic (counter)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
        end else if (start) begin
            if (count < 16) begin
                count <= count + 1;
            end
        end else begin
            count <= 5'd0;
        end
    end

    // Datapath logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc <= 32'b0;
            shifted_bin <= 16'b0;
        end else if (start) begin
            if (count == 0) begin
                acc <= 32'b0;
                shifted_bin <= bin;
            end else if (count <= 16) begin
                if (ain[count-1]) begin
                    acc <= acc + {16'b0, shifted_bin};
                end
                shifted_bin <= shifted_bin << 1;
            end
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = op_done;

endmodule