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
    wire count_en = start && (count < 17);
    wire count_rst = !rst_n || (!start && count == 0);
    reg done_reg;

    // Datapath registers
    reg [15:0] areg;
    reg [31:0] acc;
    reg [15:0] shifted_bin;
    reg [31:0] acc_stage2;
    
    // Clock gating signals
    wire shift_clk_en = (count < 16) && start;
    wire shift_clk = clk & shift_clk_en;

    // Control logic (counter)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            done_reg <= 1'b0;
        end else begin
            if (count_rst) begin
                count <= 5'd0;
            end else if (count_en) begin
                count <= count + 1;
            end
            
            // Simplified done generation
            done_reg <= (count == 16);
        end
    end

    // Stage 1: Shift and conditional add
    always @(posedge shift_clk or negedge rst_n) begin
        if (!rst_n) begin
            shifted_bin <= 16'b0;
        end else if (count == 0) begin
            shifted_bin <= bin;
        end else begin
            shifted_bin <= shifted_bin << 1;
        end
    end

    // Stage 1: Accumulator
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            acc <= 32'b0;
        end else if (start) begin
            if (count == 0) begin
                areg <= ain;
                acc <= 32'b0;
            end else if (count < 17) begin
                if (areg[count-1]) begin
                    acc <= acc + {16'b0, shifted_bin};
                end
            end
        end
    end

    // Stage 2: Pipeline register
    always @(posedge clk) begin
        acc_stage2 <= acc;
    end

    // Output assignments
    assign yout = acc_stage2;
    assign done = done_reg;

endmodule