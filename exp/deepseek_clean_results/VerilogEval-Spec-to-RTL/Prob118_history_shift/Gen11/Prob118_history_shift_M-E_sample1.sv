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

    reg [31:0] history_buffer [0:31];  // Circular buffer
    reg [4:0] head_ptr;                // Points to current head (youngest)
    reg [4:0] write_ptr;               // Points to next write location
    reg [31:0] output_reg;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize buffer and pointers
            for (i = 0; i < 32; i = i + 1)
                history_buffer[i] <= 1'b0;
            head_ptr <= 5'd0;
            write_ptr <= 5'd1;
            output_reg <= 32'b0;
        end else if (train_mispredicted) begin
            // Handle misprediction - load train_history + train_taken
            for (i = 0; i < 31; i = i + 1)
                history_buffer[i] <= train_history[i+1];
            history_buffer[31] <= train_taken;
            head_ptr <= 5'd31;
            write_ptr <= 5'd0;
            output_reg <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Normal prediction - circular buffer update
            history_buffer[write_ptr] <= predict_taken;
            head_ptr <= write_ptr;
            write_ptr <= (write_ptr == 5'd31) ? 5'd0 : write_ptr + 5'd1;
            
            // Generate output by reading circular buffer
            for (i = 0; i < 32; i = i + 1)
                output_reg[i] <= history_buffer[(head_ptr >= i) ? 
                                (head_ptr - i) : (32 + head_ptr - i)];
        end
    end

    assign predict_history = output_reg;

endmodule