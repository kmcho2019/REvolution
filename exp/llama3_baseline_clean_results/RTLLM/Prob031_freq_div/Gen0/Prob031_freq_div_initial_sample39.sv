module freq_div (
    input  logic        CLK_in,  // Input clock signal
    input  logic        RST,     // Reset signal
    output logic        CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output logic        CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output logic        CLK_1    // Output clock signal with a frequency of CLK_in divided by 100
);

logic [1:0]   cnt_2;    // Counter for CLK_50 generation
logic [2:0]   cnt_10;   // Counter for CLK_10 generation
logic [5:0]   cnt_100;  // Counter for CLK_1 generation

always_ff @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        cnt_2 <= 2'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 3'b0;
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b0;
    end else begin
        // Generate CLK_50
        if (cnt_2 == 2'b1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 2'b0;
        end else begin
            cnt_2 <= cnt_2 + 1'b1;
        end

        // Generate CLK_10
        if (cnt_10 == 3'b100) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b0;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end

        // Generate CLK_1
        if (cnt_100 == 6'b110001) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b0;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule