module TopModule(
    input        clk,
    input        areset,
    input        j,
    input        k,
    output       out
);

// Define states
localparam [1:0] OFF = 2'b00;
localparam [1:0] ON  = 2'b01;

// Declare current state and next state reg
reg [1:0] state;
reg [1:0] next_state;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state
always @(*) begin
    case(state)
        OFF: begin
            if(j == 1'b1) begin
                next_state <= ON;
            end else begin
                next_state <= OFF;
            end
        end
        ON: begin
            if(k == 1'b1) begin
                next_state <= OFF;
            end else begin
                next_state <= ON;
            end
        end
        default: next_state <= OFF;
    endcase
end

// Combinational logic for output
always @(*) begin
    case(state)
        OFF: out <= 1'b0;
        ON:  out <= 1'b1;
        default: out <= 1'b0;
    endcase
end

endmodule