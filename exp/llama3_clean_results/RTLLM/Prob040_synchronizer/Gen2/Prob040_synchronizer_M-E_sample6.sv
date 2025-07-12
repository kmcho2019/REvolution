module synchronizer(
    input  wire            clk_a,
    input  wire            clk_b,
    input  wire            arstn,
    input  wire            brstn,
    input  wire [3:0]      data_in,
    input  wire            data_en,
    output reg  [3:0]      dataout
);

// Define the states for the FSM
typedef enum logic [1:0] {
    IDLE,
    SYNC,
    VALID
} state_t;

state_t current_state;
state_t next_state;

reg [3:0] data_reg;
reg       data_sync;
reg       data_valid;

// Clock domain crossing (CDC) module for data_en signal
reg data_en_sync;
reg data_en_sync_d1;
reg data_en_sync_d2;

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        data_en_sync <= 1'b0;
        data_en_sync_d1 <= 1'b0;
        data_en_sync_d2 <= 1'b0;
    end else begin
        data_en_sync <= data_en;
        data_en_sync_d1 <= data_en_sync;
        data_en_sync_d2 <= data_en_sync_d1;
    end
end

// FSM logic
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        current_state <= IDLE;
        data_sync <= 1'b0;
        data_valid <= 1'b0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_en_sync_d2) begin
                    current_state <= SYNC;
                    data_sync <= 1'b1;
                end else begin
                    current_state <= IDLE;
                end
            end
            SYNC: begin
                if (data_en_sync_d2) begin
                    current_state <= VALID;
                    data_valid <= 1'b1;
                end else begin
                    current_state <= IDLE;
                end
            end
            VALID: begin
                if (~data_en_sync_d2) begin
                    current_state <= IDLE;
                    data_valid <= 1'b0;
                end else begin
                    current_state <= VALID;
                end
            end
            default: begin
                current_state <= IDLE;
            end
        endcase
    end
end

// Data register logic
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'd0;
    end else if (data_en) begin
        data_reg <= data_in;
    end
end

// Output logic
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout <= 4'd0;
    end else if (data_valid) begin
        dataout <= data_reg;
    end
end

endmodule