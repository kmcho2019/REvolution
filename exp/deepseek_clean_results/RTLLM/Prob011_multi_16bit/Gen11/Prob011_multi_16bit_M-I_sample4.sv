module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // Pre-compute all shifted versions of bin
    wire [31:0] shifted_bin [0:15];
    generate
        genvar i;
        for (i=0; i<16; i=i+1) begin : shift_gen
            assign shifted_bin[i] = bin << i;
        end
    endgenerate

    reg [4:0] count;  // Counts 0-16 (5 bits)
    reg [15:0] areg;
    reg [31:0] acc;
    reg acc_en;       // Accumulator enable
    reg [31:0] selected_shift;

    // Pipeline stage 1: Shift selection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            selected_shift <= 32'b0;
            acc_en <= 1'b0;
        end else if (count > 0 && count < 17) begin
            selected_shift <= shifted_bin[count-1];
            acc_en <= areg[count-1];
        end else begin
            selected_shift <= 32'b0;
            acc_en <= 1'b0;
        end
    end

    // Pipeline stage 2: Accumulation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            areg <= 16'b0;
            acc <= 32'b0;
        end else if (start && count == 0) begin
            // Load operands and initialize
            areg <= ain;
            acc <= 32'b0;
            count <= (ain == 16'b0) ? 5'd17 : 5'd1; // Early termination
        end else if (count > 0 && count < 17) begin
            // Accumulate if enabled
            if (acc_en) begin
                acc <= acc + selected_shift;
            end
            count <= (count == 16) ? 5'd17 : count + 1;
        end else begin
            // Idle state
            count <= 5'd0;
        end
    end

    assign yout = acc;
    assign done = (count == 17);

endmodule