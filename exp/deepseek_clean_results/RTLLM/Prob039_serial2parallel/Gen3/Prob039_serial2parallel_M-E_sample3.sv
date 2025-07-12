module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [6:0] valid_chain;  // 7-bit validation shift register
    wire chain_out;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            valid_chain <= 7'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Barrel shift operation
            if (din_valid) begin
                dout_parallel <= {dout_parallel[6:0], din_serial};
            end

            // Validation chain propagation
            valid_chain <= {valid_chain[5:0], din_valid};
            
            // Output valid is the delayed chain output
            dout_valid <= chain_out;
        end
    end

    // Chain output is the 8th delayed valid (7 regs + current din_valid)
    assign chain_out = valid_chain[6] & din_valid;

endmodule