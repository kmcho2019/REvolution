module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [1:0] state;
reg en_clap_one;
reg en_clap_two;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        state <= 2'd0; // IDLE state
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
        dataout <= 4'd0;
    end else begin
        case (state)
            2'd0: begin // IDLE state
                if (data_en) begin
                    state <= 2'd1; // SYNC state
                    en_clap_one <= 1'b1;
                end
            end
            2'd1: begin // SYNC state
                en_clap_two <= en_clap_one;
                if (en_clap_two) begin
                    dataout <= data_in;
                    state <= 2'd0; // IDLE state
                end
            end
        endcase
    end
end

endmodule