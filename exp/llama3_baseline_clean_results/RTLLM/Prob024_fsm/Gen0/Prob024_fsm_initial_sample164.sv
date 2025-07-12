module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [2:0] state;  // State variable
reg [2:0] next_state;  // Next state variable

// Define the states
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

// State transition logic
always @(*) begin
    case (state)
        S0: begin
            if (IN == 1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (IN == 0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (IN == 0) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN == 1) begin
                next_state = S4;
            end else begin
                next_state = S1;
            end
        end
        S4: begin
            if (IN == 1) begin
                next_state = S5;
            end else begin
                next_state = S1;
            end
        end
        S5: begin
            if (IN == 1) begin
                next_state = S5;
            end else begin
                next_state = S1;
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end

// Output logic
assign MATCH = (state == S5) && (IN == 1);

// State register
always @(posedge CLK or posedge RST) begin
    if (RST == 1) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

endmodule