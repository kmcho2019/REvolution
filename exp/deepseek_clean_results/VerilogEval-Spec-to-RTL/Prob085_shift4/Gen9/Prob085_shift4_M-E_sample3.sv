module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

reg [3:0] shift_reg;
reg [3:0] load_buffer;
reg [1:0] shift_counter;
reg shifting;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 4'b0;
        load_buffer <= 4'b0;
        shift_counter <= 2'b0;
        shifting <= 1'b0;
    end else begin
        if (load) begin
            // Load takes priority - store data in buffer and prepare for parallel load
            load_buffer <= data;
            shift_counter <= 2'b0;
            shifting <= 1'b0;
        end else if (ena && !shifting) begin
            // Start new shift operation
            shifting <= 1'b1;
            shift_counter <= 2'b0;
        end

        if (shifting) begin
            // Perform serial shift operation
            shift_reg <= {1'b0, shift_reg[3:1]};
            shift_counter <= shift_counter + 1;
            
            // Complete after 4 shifts
            if (shift_counter == 2'b11) begin
                shifting <= 1'b0;
            end
        end

        // Parallel load happens when not shifting and load was requested
        if (!shifting && load) begin
            shift_reg <= load_buffer;
        end
    end
end

// Output is always the current shift register value
always @(*) begin
    q = shift_reg;
end

endmodule