module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

// Internal signals
reg [3:0] data_reg;
reg en_data_reg;
reg en_clap_one;
reg en_clap_two;
reg [1:0] state; // State machine states

// State machine states
enum logic [1:0] {
    IDLE = 2'b00,
    CAPTURE = 2'b01,
    SYNCHRONIZE = 2'b10
} state_next;

// Data capture
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'b0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (data_en) begin
                    data_reg <= data_in;
                    en_data_reg <= 1'b1;
                    state <= CAPTURE;
                end
            end
            CAPTURE: begin
                state <= SYNCHRONIZE;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

// Enable control registers
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
        dataout <= 4'd0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
        if (en_clap_two) begin
            dataout <= data_reg;
        end
    end
end

endmodule