module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_first; // Register to store the first 8-bit data input
reg [7:0] data_second; // Register to store the second 8-bit data input
reg [1:0] state; // State machine with 'idle', 'data_capture', and 'data_valid' states

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_first  <= 8'd0;
        data_second <= 8'd0;
        state      <= 2'd0; // Initialize state to 'idle'
    end
    else begin
        case (state)
            2'd0: begin // 'idle' state
                if (valid_in) begin
                    data_first  <= data_in;
                    state      <= 2'd1; // Transition to 'data_capture' state
                end
            end
            2'd1: begin // 'data_capture' state
                if (valid_in) begin
                    data_second <= data_in;
                    state      <= 2'd2; // Transition to 'data_valid' state
                end
            end
            2'd2: begin // 'data_valid' state
                state      <= 2'd0; // Transition back to 'idle' state
            end
            default: begin
                state      <= 2'd0; // Default state is 'idle'
            end
        endcase
    end
end

assign valid_out = (state == 2'd2); // Assert valid_out in 'data_valid' state
assign data_out = (state == 2'd2) ? {data_first, data_second} : 16'd0;

endmodule