module BitDFF_negclk_sync_reset_seq (
    input clk,
    input reset,
    input [2:0] load_index,
    input load_en,
    input d,
    output reg q,
    input reset_bit  // bit from reset value to load during reset sequencing
);
    always @(negedge clk) begin
        if (reset) begin
            if (load_en && load_index == 0) begin
                q <= reset_bit;
            end
            else if (load_en && load_index != 0) begin
                q <= reset_bit;
            end
            else begin
                // maintain q if no loading this cycle
                q <= q;
            end
        end else begin
            q <= d;
        end
    end
endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);
    // Reset value constant
    localparam [7:0] RESET_VAL = 8'h34;

    // Counter to sequence loading of reset bits (0 to 7)
    reg [2:0] reset_counter;
    wire resetting = reset;

    // Enable loading bits from RESET_VAL during reset
    wire load_en = resetting;

    // Increment reset_counter while resetting, hold or reset it when not resetting
    always @(negedge clk) begin
        if (resetting) begin
            if (reset_counter == 3'd7)
                reset_counter <= 3'd0;  // wrap around or hold at max
            else
                reset_counter <= reset_counter + 1;
        end else begin
            reset_counter <= 3'd0;
        end
    end

    // Instantiate 8 bit DFFs, each loads its reset bit when reset asserted and load_en active
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dffs
            BitDFF_negclk_sync_reset_seq dff (
                .clk(clk),
                .reset(reset),
                .load_index(reset_counter),
                .load_en(load_en && (reset_counter == i)),
                .d(d[i]),
                .q(q[i]),
                .reset_bit(RESET_VAL[i])
            );
        end
    endgenerate

endmodule