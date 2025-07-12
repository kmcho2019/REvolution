module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] current_history;
    reg [31:0] shadow_history;
    wire update_enable = areset || train_mispredicted || predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_history <= 32'b0;
            shadow_history <= 32'b0;
        end else if (update_enable) begin
            // Parallel mux implementation for better timing
            case ({train_mispredicted, predict_valid})
                2'b10: begin // Misprediction has highest priority
                    current_history <= {train_history[30:0], train_taken};
                    shadow_history <= train_history;
                end
                2'b01: begin // Normal prediction
                    shadow_history <= current_history;
                    current_history <= {current_history[30:0], predict_taken};
                end
                default: begin // No operation (shouldn't occur with update_enable)
                    current_history <= current_history;
                    shadow_history <= shadow_history;
                end
            endcase
        end
    end

    assign predict_history = current_history;

endmodule