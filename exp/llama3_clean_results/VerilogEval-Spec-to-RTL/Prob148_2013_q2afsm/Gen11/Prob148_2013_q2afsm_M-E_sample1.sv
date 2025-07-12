module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;
reg [1:0] current_grant;
reg [1:0] next_grant;

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00;  
        current_grant <= 2'b00;
    end else begin
        current_state <= next_state;
        current_grant <= next_grant;
    end
end

always @(*) begin
    case (current_state)
        2'b00:  
            if (r[0] || r[1] || r[2]) begin
                next_state = 2'b01;
                next_grant = get_highest_priority(r);
            end else begin
                next_state = 2'b00;
                next_grant = 2'b00;
            end
        2'b01:  
            if (~r[current_grant]) begin
                next_state = 2'b00;
                next_grant = 2'b00;
            end else begin
                next_state = 2'b01;
                next_grant = get_next_grant(current_grant, r);
            end
        default:
            next_state = 2'b00;  
            next_grant = 2'b00;
    endcase
end

function [1:0] get_highest_priority(input [2:0] r);
    if (r[0]) begin
        get_highest_priority = 2'b01;
    end else if (r[1]) begin
        get_highest_priority = 2'b10;
    end else if (r[2]) begin
        get_highest_priority = 2'b11;
    end else begin
        get_highest_priority = 2'b00;
    end
endfunction

function [1:0] get_next_grant(input [1:0] current_grant, input [2:0] r);
    case (current_grant)
        2'b01:  
            if (r[1]) begin
                get_next_grant = 2'b10;
            end else if (r[2]) begin
                get_next_grant = 2'b11;
            end else begin
                get_next_grant = 2'b01;
            end
        2'b10:  
            if (r[2]) begin
                get_next_grant = 2'b11;
            end else if (r[0]) begin
                get_next_grant = 2'b01;
            end else begin
                get_next_grant = 2'b10;
            end
        2'b11:  
            if (r[0]) begin
                get_next_grant = 2'b01;
            end else if (r[1]) begin
                get_next_grant = 2'b10;
            end else begin
                get_next_grant = 2'b11;
            end
        default:
            get_next_grant = 2'b00;  
    endcase
endfunction

assign g[0] = (current_grant == 2'b01);
assign g[1] = (current_grant == 2'b10);
assign g[2] = (current_grant == 2'b11);

endmodule