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

reg [7:0] segment0, segment1, segment2, segment3;
reg [7:0] new_segment0, new_segment1, new_segment2, new_segment3;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        segment0 <= 8'd0;
        segment1 <= 8'd0;
        segment2 <= 8'd0;
        segment3 <= 8'd0;
    end else begin
        if (train_mispredicted) begin
            segment0 <= {train_history[7:0], train_taken};
            segment1 <= train_history[15:8];
            segment2 <= train_history[23:16];
            segment3 <= train_history[31:24];
        end else if (predict_valid) begin
            segment0 <= {segment0[6:0], predict_taken};
            segment1 <= segment1;
            segment2 <= segment2;
            segment3 <= segment3;
        end else begin
            segment0 <= segment0;
            segment1 <= segment1;
            segment2 <= segment2;
            segment3 <= segment3;
        end
    end
end

assign predict_history = {segment3, segment2, segment1, segment0};

endmodule