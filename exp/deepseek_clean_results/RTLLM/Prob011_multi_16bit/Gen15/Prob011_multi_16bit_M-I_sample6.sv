module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output wire done
);

    // Control signals
    reg [4:0] count;
    wire count_en = start && (count < 17);
    wire op_done = (count == 16);  // Simplified comparison
    
    // Datapath registers
    reg [15:0] areg;
    reg [31:0] acc;
    reg [15:0] shifted_bin;
    reg acc_valid;
    
    // Clock gating signals
    wire shift_clk_en = (count < 16) && start;
    wire shift_clk = clk & shift_clk_en;
    
    // Control logic (counter)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
        end else begin
            if (start) begin
                if (count < 17) 
                    count <= count + 1;
            end else begin
                count <= 5'd0;
            end
        end
    end

    // Datapath logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            acc <= 32'b0;
            shifted_bin <= 16'b0;
            acc_valid <= 1'b0;
        end else begin
            if (start) begin
                if (count == 0) begin
                    areg <= ain;
                    acc <= 32'b0;
                    shifted_bin <= bin;
                    acc_valid <= 1'b0;
                end else if (count <= 16) begin
                    if (areg[count-1]) begin
                        acc <= acc + {16'b0, shifted_bin};
                    end
                    shifted_bin <= shifted_bin << 1;
                    acc_valid <= (count == 16);
                end
            end else begin
                acc_valid <= 1'b0;
            end
        end
    end

    // Output pipeline register
    always @(posedge clk) begin
        if (acc_valid) begin
            yout <= acc;
        end
    end

    // Output assignments
    assign done = op_done;

endmodule