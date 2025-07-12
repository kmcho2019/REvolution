module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] state;    // Tracks accumulation state (0-3)
    wire [1:0] next_state;
    wire [9:0] next_sum;

    // Combinational next state logic
    assign next_state = (!rst_n) ? 2'b00 : 
                       (valid_in) ? (state + 1'b1) : state;

    // Combinational sum calculation
    assign next_sum = (!rst_n) ? 10'b0 :
                     (valid_in) ? data_out + data_in : data_out;

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;
            data_out <= 10'b0;
        end else begin
            state <= next_state;
            // Only update sum when in accumulation phase (state < 3)
            if (valid_in && (state != 2'b11)) begin
                data_out <= next_sum;
            end else if (state == 2'b11) begin
                data_out <= 10'b0;  // Reset after output
            end
        end
    end

    // Output valid only when completing 4th input
    always @(*) begin
        valid_out = (state == 2'b11) && valid_in;
    end

endmodule