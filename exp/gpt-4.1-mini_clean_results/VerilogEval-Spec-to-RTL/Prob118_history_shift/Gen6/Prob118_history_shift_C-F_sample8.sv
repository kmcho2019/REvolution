module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    wire update_enable = train_mispredicted | predict_valid;
    wire [31:0] next_history = train_mispredicted ? 
                                {train_history[30:0], train_taken} : 
                                {predict_history[30:0], predict_taken};

    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else if (update_enable)
            predict_history <= next_history;
        // else hold current value to reduce toggling
    end

endmodule