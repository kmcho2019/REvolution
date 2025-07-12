module TopModule (
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input   [31:0]   train_history,
    output  [31:0]   predict_history
);

reg [31:0] history;
reg [1:0] state;
reg [31:0] next_history;

localparam IDLE = 2'b00;
localparam UPDATE = 2'b01;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        history <= 32'd0;
    end else begin
        case (state)
            IDLE: begin
                if (train_mispredicted || predict_valid) begin
                    state <= UPDATE;
                end
            end
            UPDATE: begin
                if (train_mispredicted) begin
                    history <= {train_history, train_taken};
                end else if (predict_valid) begin
                    history <= {history[30:0], predict_taken};
                end
                state <= IDLE;
            end
        endcase
    end
end

assign predict_history = history;

endmodule