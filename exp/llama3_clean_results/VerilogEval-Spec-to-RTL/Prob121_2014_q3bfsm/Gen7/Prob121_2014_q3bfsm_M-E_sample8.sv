module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] state;
reg [2:0] next_state;

// Define the state encoding
always @(*) begin
    case (state)
        3'b000: begin
            if (!x) begin
                next_state = 3'b000;
            end else begin
                next_state = 3'b001;
            end
        end
        3'b001: begin
            if (!x) begin
                next_state = 3'b001;
            end else begin
                next_state = 3'b100;
            end
        end
        3'b010: begin
            if (!x) begin
                next_state = 3'b010;
            end else begin
                next_state = 3'b001;
            end
        end
        3'b011: begin
            if (!x) begin
                next_state = 3'b001;
            end else begin
                next_state = 3'b010;
            end
        end
        3'b100: begin
            if (!x) begin
                next_state = 3'b011;
            end else begin
                next_state = 3'b100;
            end
        end
        default: next_state = 3'b000;
    endcase
end

// Define the output logic
always @(*) begin
    case (state)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
    end else begin
        state <= next_state;
    end
end

endmodule

module binary_tree(
    input [2:0] state,
    input x,
    output reg [2:0] next_state
);

// Level 1
reg [2:0] level1_next_state;

always @(*) begin
    if (state == 3'b000 || state == 3'b001) begin
        if (!x) begin
            level1_next_state = 3'b000;
        end else begin
            level1_next_state = 3'b001;
        end
    end else if (state == 3'b010 || state == 3'b011) begin
        if (!x) begin
            level1_next_state = 3'b001;
        end else begin
            level1_next_state = 3'b010;
        end
    end else begin
        if (!x) begin
            level1_next_state = 3'b011;
        end else begin
            level1_next_state = 3'b100;
        end
    end
end

// Level 2
always @(*) begin
    if (level1_next_state == 3'b001) begin
        if (x) begin
            next_state = 3'b100;
        end else begin
            next_state = 3'b001;
        end
    end else if (level1_next_state == 3'b010) begin
        if (x) begin
            next_state = 3'b001;
        end else begin
            next_state = 3'b010;
        end
    end else if (level1_next_state == 3'b011) begin
        if (x) begin
            next_state = 3'b010;
        end else begin
            next_state = 3'b001;
        end
    end else begin
        if (x) begin
            next_state = 3'b100;
        end else begin
            next_state = 3'b011;
        end
    end
end

endmodule