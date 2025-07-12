module TopModule(
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output reg [31:0] predict_history
);

reg [1:0] state;
reg [31:0] temp_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // IDLE state
        predict_history <= 32'd0;
    end else begin
        case (state)
            2'b00: // IDLE state
                if (predict_valid) begin
                    state <= 2'b01; // UPDATE state
                    temp_history <= {predict_history[30:0], predict_taken};
                end else if (train_mispredicted) begin
                    state <= 2'b01; // UPDATE state
                    temp_history <= {train_history, train_taken};
                end
            2'b01: // UPDATE state
                begin
                    predict_history <= temp_history;
                    state <= 2'b00; // IDLE state
                end
            default: state <= 2'b00; // IDLE state
        endcase
    end
end

endmodule