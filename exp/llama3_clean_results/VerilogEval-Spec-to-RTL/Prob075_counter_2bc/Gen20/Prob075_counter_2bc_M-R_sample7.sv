module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;

// Define the states (binary encoding for simplicity)
localparam IDLE = 2'b00;
localparam LOW = 2'b01;
localparam MIDDLE = 2'b10;
localparam HIGH = 2'b11;

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= LOW; // Asynchronous reset to the LOW state
    end else if (train_valid) begin
        if (train_taken) begin
            if (state_reg == HIGH) begin
                state_reg <= HIGH; // Saturate at HIGH
            end else begin
                state_reg <= state_reg + 1;
            end
        end else begin
            if (state_reg == IDLE) begin
                state_reg <= IDLE; // Saturate at IDLE
            end else begin
                state_reg <= state_reg - 1;
            end
        end
    end else begin
        state_reg <= state_reg; // No change when not training
    end
end

assign state = state_reg;

endmodule