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

    reg [31:0] history_buffer;
    reg [4:0] write_ptr;  // Points to current insertion location
    wire [4:0] next_ptr = write_ptr + 1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_buffer <= 32'b0;
            write_ptr <= 5'd0;
        end else if (train_mispredicted) begin
            // Load history and append actual taken
            history_buffer <= {train_history[30:0], train_taken};
            write_ptr <= 5'd31;  // Point to newly written bit
        end else if (predict_valid) begin
            // Circular write - overwrite oldest entry
            history_buffer[write_ptr] <= predict_taken;
            write_ptr <= next_ptr;
        end
    end

    // Circular read-out with proper ordering (youngest at [0])
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : history_mapping
            assign predict_history[i] = history_buffer[(write_ptr + i + 1) % 32];
        end
    endgenerate

endmodule