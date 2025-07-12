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
reg en_data_reg;
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

// Data capture and synchronization
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'd0;
    end else begin
        data_reg <= data_en? data_in : data_reg;
        en_data_reg <= data_en;
    end
end

// Delay enable signal by two clk_b cycles
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_data_reg <= 1'd0;
    end else begin
        en_data_reg <= en_data_reg;
    end
end

endmodule