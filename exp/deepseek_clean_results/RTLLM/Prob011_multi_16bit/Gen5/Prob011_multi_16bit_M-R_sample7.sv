module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    reg [4:0] count;  // Need 5 bits to count to 16 (0-16)
    reg [15:0] areg;
    reg [31:0] breg_shifted [0:15];  // Pre-shifted versions of breg
    reg [31:0] acc;
    reg load;

    // Generate all possible shifted versions of breg in parallel
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < 16; i = i + 1) begin
                breg_shifted[i] <= 32'b0;
            end
        end else if (load) begin
            for (integer i = 0; i < 16; i = i + 1) begin
                breg_shifted[i] <= bin << i;
            end
        end
    end

    // Control counter and load signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            load <= 1'b0;
        end else begin
            load <= start && (count == 0);
            
            if (start) begin
                if (count < 17) begin
                    count <= count + 1;
                end
            end else begin
                count <= 5'd0;
            end
        end
    end

    // Multiplicand register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
        end else if (load) begin
            areg <= ain;
        end
    end

    // Accumulator
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc <= 32'b0;
        end else if (load) begin
            acc <= 32'b0;
        end else if ((count > 0) && (count < 17)) begin
            if (areg[count-1]) begin
                acc <= acc + breg_shifted[count-1];
            end
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (count == 16);

endmodule