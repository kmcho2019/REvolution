module TopModule(
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    // Enable update only when an event occurs
    wire update_enable = train_mispredicted || predict_valid;

    reg update_enable_d;
    always @(posedge clk or posedge areset) begin
        if (areset)
            update_enable_d <= 1'b0;
        else
            update_enable_d <= update_enable;
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable_d) begin
            // Mux updates to reduce combinational logic
            if (train_mispredicted)
                predict_history <= {train_history[30:0], train_taken};
            else if (predict_valid)
                predict_history <= {predict_history[30:0], predict_taken};
        end
    end

endmodule