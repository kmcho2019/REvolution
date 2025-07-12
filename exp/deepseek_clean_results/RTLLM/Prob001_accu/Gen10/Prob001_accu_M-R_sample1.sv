module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State encoding for the counter
    localparam [1:0] S0 = 2'b00,
                     S1 = 2'b01,
                     S2 = 2'b10,
                     S3 = 2'b11;

    reg [1:0] state, next_state;
    reg [9:0] accumulator;
    wire [9:0] next_accumulator;

    // Next state logic
    always @(*) begin
        if (!rst_n)
            next_state = S0;
        else if (valid_in) begin
            case (state)
                S0: next_state = S1;
                S1: next_state = S2;
                S2: next_state = S3;
                S3: next_state = S0;
                default: next_state = S0;
            endcase
        end
        else
            next_state = state;
    end

    // Accumulator update logic
    assign next_accumulator = (state == S3) ? 10'b0 : (accumulator + data_in);

    // State and accumulator registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            accumulator <= 10'b0;
            data_out <= 10'b0;
        end
        else begin
            state <= next_state;
            accumulator <= next_accumulator;
            
            // Output the sum when we reach state S3
            if (valid_in && (state == S3))
                data_out <= accumulator + data_in;
        end
    end

    // Valid output is combinational based on state
    always @(*) begin
        valid_out = (valid_in && (state == S3));
    end

endmodule