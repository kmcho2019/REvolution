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
    wire op_done = count[4];  // count == 16 (10000) or 17 (10001)

    // Datapath registers
    reg [15:0] areg;
    reg [31:0] acc;
    
    // Pre-compute all possible shifted versions of bin
    wire [31:0] bin_shifted [0:15];
    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign bin_shifted[i] = bin << i;
        end
    endgenerate

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
            acc <= 32'b0;
        end else if (start && count == 0) begin
            areg <= ain;
            acc <= 32'b0;
        end else if (count > 0 && count < 17) begin
            if (areg[count-1]) begin
                acc <= acc + bin_shifted[count-1];
            end
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = op_done && (count[3:0] == 4'b0001);  // count == 17

endmodule