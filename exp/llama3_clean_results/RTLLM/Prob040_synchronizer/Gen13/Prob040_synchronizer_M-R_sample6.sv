module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg req;
reg ack;
reg en_data_reg;
reg en_clap_one;
reg [1:0] state;

// State machine
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        state <= 2'd0; // IDLE state
        dataout <= 4'd0;
    end else begin
        case (state)
            2'd0: begin // IDLE state
                if (en_data_reg) begin
                    state <= 2'd1; // SYNC state
                end
            end
            2'd1: begin // SYNC state
                dataout <= data_reg;
                state <= 2'd0; // IDLE state
            end
        endcase
    end
end

// Data capture
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        req <= 1'b0;
    end else if (data_en) begin
        data_reg <= data_in;
        req <= 1'b1;
    end else if (ack) begin
        req <= 1'b0;
    end
end

// Synchronization
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_data_reg <= 1'b0;
        en_clap_one <= 1'b0;
        ack <= 1'b0;
    end else begin
        en_data_reg <= req;
        en_clap_one <= en_data_reg;
        if (en_clap_one) begin
            ack <= 1'b1;
        end else begin
            ack <= 1'b0;
        end
    end
end

endmodule