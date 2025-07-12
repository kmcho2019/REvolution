module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output CLK_10,
    output CLK_1
);

    // Counter for 10MHz clock (divide by 10)
    reg [2:0] cnt_10;  // Counts 0-4 (3 bits sufficient)
    
    // Counter for 1MHz clock (divide by 100)
    reg [5:0] cnt_100; // Counts 0-49 (6 bits sufficient)

    // Internal toggle registers
    reg toggle_50;
    reg toggle_10;
    reg toggle_1;

    // CLK_50 generation (divide by 2) using XOR
    assign CLK_50 = toggle_50;

    // CLK_10 generation (divide by 10)
    assign CLK_10 = toggle_10;

    // CLK_1 generation (divide by 100)
    assign CLK_1 = toggle_1;

    // Combined counter update logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            toggle_50 <= 1'b0;
            toggle_10 <= 1'b0;
            toggle_1 <= 1'b0;
            cnt_10 <= 3'b0;
            cnt_100 <= 6'b0;
        end else begin
            // CLK_50 toggle on every clock
            toggle_50 <= ~toggle_50;

            // CLK_10 counter logic
            if (cnt_10 == 3'd4) begin
                toggle_10 <= ~toggle_10;
                cnt_10 <= 3'b0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // CLK_1 counter logic
            if (cnt_100 == 6'd49) begin
                toggle_1 <= ~toggle_1;
                cnt_100 <= 6'b0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule