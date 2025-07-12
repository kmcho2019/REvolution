module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Timing parameters
localparam GREEN_TIME  = 8'd60;
localparam YELLOW_TIME = 8'd5;
localparam RED_TIME    = 8'd10;
localparam MIN_GREEN   = 8'd10;

// State encoding
localparam [1:0] ST_RED    = 2'b00;
localparam [1:0] ST_YELLOW = 2'b01;
localparam [1:0] ST_GREEN  = 2'b10;

reg [1:0] current_state;
reg [7:0] counter;

// Next state and output logic (combinational)
wire [1:0] next_state;
assign next_state = (!rst_n) ? ST_RED : 
                   (counter == 0) ? 
                   (current_state == ST_RED)    ? ST_GREEN :
                   (current_state == ST_YELLOW) ? ST_RED :
                   (current_state == ST_GREEN)  ? ST_YELLOW :
                   current_state : current_state;

// Output assignments
assign red    = (current_state == ST_RED);
assign yellow = (current_state == ST_YELLOW);
assign green  = (current_state == ST_GREEN);
assign clock  = counter;

// Counter and state sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= ST_RED;
        counter <= RED_TIME;
    end else begin
        current_state <= next_state;
        
        // Counter update logic
        if (counter == 0) begin
            case (next_state)
                ST_RED:    counter <= RED_TIME;
                ST_YELLOW: counter <= YELLOW_TIME;
                ST_GREEN:  counter <= GREEN_TIME;
            endcase
        end else if (pass_request && green && (counter > MIN_GREEN)) begin
            counter <= MIN_GREEN;
        end else begin
            counter <= counter - 1;
        end
    end
end

endmodule