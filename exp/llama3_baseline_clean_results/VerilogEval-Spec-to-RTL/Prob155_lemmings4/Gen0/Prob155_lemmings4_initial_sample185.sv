module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
`define IDLE_LEFT 3'b000
`define IDLE_RIGHT 3'b001
`define FALLING 3'b010
`define DIGGING_LEFT 3'b011
`define DIGGING_RIGHT 3'b100
`define SPLATTERED 3'b101

// State variable
reg [2:0] state;
reg [2:0] nextState;

// Counter for falling duration
reg [5:0] fall_counter;
reg [5:0] next_fall_counter;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= `IDLE_LEFT;
        fall_counter <= 6'd0;
    end else begin
        state <= nextState;
        fall_counter <= next_fall_counter;
    end
end

// Combinational logic
always @(*) begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    
    case(state)
        `IDLE_LEFT: begin
            walk_left = 1'b1;
            if(dig && ground) begin
                nextState = `DIGGING_LEFT;
            end else if(!ground) begin
                nextState = `FALLING;
            end else if(bump_left || (bump_right && !bump_left)) begin
                nextState = `IDLE_RIGHT;
            end else begin
                nextState = `IDLE_LEFT;
            end
        end
        `IDLE_RIGHT: begin
            walk_right = 1'b1;
            if(dig && ground) begin
                nextState = `DIGGING_RIGHT;
            end else if(!ground) begin
                nextState = `FALLING;
            end else if(bump_right || (bump_left && !bump_right)) begin
                nextState = `IDLE_LEFT;
            end else begin
                nextState = `IDLE_RIGHT;
            end
        end
        `FALLING: begin
            aaah = 1'b1;
            if(ground) begin
                if(fall_counter > 6'd20) begin
                    nextState = `SPLATTERED;
                end else if(state == `FALLING) begin
                    if(bump_left) begin
                        nextState = `IDLE_RIGHT;
                    end else if(bump_right) begin
                        nextState = `IDLE_LEFT;
                    end else begin
                        if(dig) begin
                            nextState = (state == `DIGGING_LEFT) ? `IDLE_LEFT : `IDLE_RIGHT;
                        end else begin
                            nextState = (state == `DIGGING_LEFT) ? `IDLE_LEFT : `IDLE_RIGHT;
                        end
                    end
                end else begin
                    nextState = (state == `IDLE_LEFT) ? `IDLE_LEFT : `IDLE_RIGHT;
                end
            end else begin
                nextState = `FALLING;
            end
        end
        `DIGGING_LEFT: begin
            digging = 1'b1;
            walk_left = 1'b1;
            if(!ground) begin
                nextState = `FALLING;
            end else if(bump_left || (bump_right && !bump_left)) begin
                nextState = `IDLE_RIGHT;
            end else begin
                nextState = `DIGGING_LEFT;
            end
        end
        `DIGGING_RIGHT: begin
            digging = 1'b1;
            walk_right = 1'b1;
            if(!ground) begin
                nextState = `FALLING;
            end else if(bump_right || (bump_left && !bump_right)) begin
                nextState = `IDLE_LEFT;
            end else begin
                nextState = `DIGGING_RIGHT;
            end
        end
        `SPLATTERED: begin
            nextState = `SPLATTERED;
        end
    endcase
    
    if(state == `FALLING) begin
        next_fall_counter = fall_counter + 1;
    end else begin
        next_fall_counter = 6'd0;
    end
end

endmodule