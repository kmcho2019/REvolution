module synchronizer(
    input  clk_a,
    input  clk_b,
    input  arstn,
    input  brstn,
    input  [3:0] data_in,
    input  data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg [1:0] state; // 0: idle, 1: capture, 2: transfer
reg [3:0] dataout_reg;

localparam IDLE = 2'd0;
localparam CAPTURE = 2'd1;
localparam TRANSFER = 2'd2;

// Use continuous assignment for direct connections
assign dataout = dataout_reg;

always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        state <= IDLE;
        data_reg <= 4'd0;
    end else begin
        case (state)
            IDLE: begin
                if (data_en) begin
                    data_reg <= data_in;
                    state <= CAPTURE;
                end
            end
            CAPTURE: begin
                if (~data_en) begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout_reg <= 4'd0;
    end else begin
        case (state)
            TRANSFER: begin
                dataout_reg <= data_reg;
                state <= IDLE;
            end
            CAPTURE: begin
                state <= TRANSFER;
            end
            default: ;
        endcase
    end
end

endmodule