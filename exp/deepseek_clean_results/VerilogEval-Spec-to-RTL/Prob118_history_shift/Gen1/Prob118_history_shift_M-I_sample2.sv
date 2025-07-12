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

    reg [31:0] history_reg;
    reg [4:0] ptr; // Circular buffer pointer
    wire update_en = predict_valid | train_mispredicted;
    wire gated_clk = clk & (update_en | areset);

    always @(posedge gated_clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
            ptr <= 5'b0;
        end else if (train_mispredicted) begin
            // Rollback: load from train_history and append train_taken
            history_reg <= {train_history[30:0], train_taken};
            ptr <= 5'd31; // Point to the newest entry
        end else if (predict_valid) begin
            // Circular buffer update
            ptr <= ptr + 1;
            history_reg[ptr] <= predict_taken;
        end
    end

    // Circular to linear conversion for output
    assign predict_history = {
        history_reg[ptr],
        history_reg[ptr-1],
        history_reg[ptr-2],
        history_reg[ptr-3],
        history_reg[ptr-4],
        history_reg[ptr-5],
        history_reg[ptr-6],
        history_reg[ptr-7],
        history_reg[ptr-8],
        history_reg[ptr-9],
        history_reg[ptr-10],
        history_reg[ptr-11],
        history_reg[ptr-12],
        history_reg[ptr-13],
        history_reg[ptr-14],
        history_reg[ptr-15],
        history_reg[ptr-16],
        history_reg[ptr-17],
        history_reg[ptr-18],
        history_reg[ptr-19],
        history_reg[ptr-20],
        history_reg[ptr-21],
        history_reg[ptr-22],
        history_reg[ptr-23],
        history_reg[ptr-24],
        history_reg[ptr-25],
        history_reg[ptr-26],
        history_reg[ptr-27],
        history_reg[ptr-28],
        history_reg[ptr-29],
        history_reg[ptr-30],
        history_reg[ptr-31]
    };

endmodule